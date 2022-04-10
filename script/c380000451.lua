--Meklord Army Regeneration
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={63468625}
s.listed_series={0x6013}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(s.checkop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetLabelObject(e1)
		e2:SetCondition(s.flipcon)
		e2:SetOperation(s.flipop)
		Duel.RegisterEffect(e2,tp)
	end
	e:SetLabel(1)
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsCode(63468625)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.cfilter,1,nil,tp) then
		Duel.RegisterFlagEffect(ep,id,RESET_EVENT+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		e:SetLabel(Duel.GetTurnCount())
	end
end
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(0x6013)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
	return aux.CanActivateSkill(tp)
	and Duel.GetFlagEffect(ep,id)>0
	and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
	and g:GetClassCount(Card.GetCode)>=2
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Return 2 "Meklord Army" monsters with different names from your Graveyard to your hand
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		local sg=aux.SelectUnselectGroup(g,e,tp,2,2,aux.dncheck,1,tp,HINTMSG_ATOHAND)
		Duel.SendtoHand(sg,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
