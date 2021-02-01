--Roll 'n' Boost
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		s[2]=0
		s[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.roll_dice=true
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not s[tp] then s[tp]=Duel.GetLP(tp) end
	if s[tp]>Duel.GetLP(tp) then
		s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
		s[tp]=Duel.GetLP(tp)
	end
	if not s[1-tp] then s[1-tp]=Duel.GetLP(1-tp) end
	if s[1-tp]>Duel.GetLP(1-tp) then
		s[2+(1-tp)]=s[2+(1-tp)]+(s[1-tp]-Duel.GetLP(1-tp))
		s[1-tp]=Duel.GetLP(1-tp)
	end
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and not c:IsPublic()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and s[2+tp]>=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--reveal
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		local dc=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(dc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	s[2+tp]=0
	--flip during End phase
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.flip)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.flip(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
