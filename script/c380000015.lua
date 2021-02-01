--Draw Sense: Spell/Trap
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
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
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP):GetClassCount(Card.GetCode)>=3
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--flag register
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--flag check
	if Duel.GetFlagEffect(ep,id)==0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
	and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL+TYPE_TRAP)
	and s[2+tp]>=1000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP):RandomSelect(tp,1)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
		s[2+tp]=0
	end
end
