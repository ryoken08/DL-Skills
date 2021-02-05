--Guardian Call
local s,id=GetID()
function s.initial_effect(c)
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
s.listed_series={0x52}
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
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x52)
	and s[2+tp]>=1800
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x52):RandomSelect(tp,1)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,g)
		s[2+tp]=0
	end
end
