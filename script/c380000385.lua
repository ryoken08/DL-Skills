--Sinister Calling
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
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
end
s.listed_names={94820406,12071500,45659520}
s.listed_series={0x3008,0x6008}
function s.filter(c)
	return (c:IsMonster() and c:IsSetCard(0x6008)) or c:IsCode(94820406,12071500)
end
function s.filter2(c)
	return c:IsMonster() and not (c:IsSetCard(0x3008) or c:IsSetCard(0x6008))
end
function s.exfilter(c)
	return c:IsMonster() and not c:IsType(TYPE_FUSION)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,10,nil)
	   and not Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)
	   and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.disfilter(c)
	return c:IsMonster() and c:IsSetCard(0x6008)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 and Duel.GetFlagEffect(ep,id+1)>0 then return end
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,94820406,12071500))
	local b2=Duel.GetFlagEffect(ep,id+1)==0
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
	and Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--discard 1 Evil HERO monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=g:GetFirst()
	if g1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
		e1:SetReset(RESET_CHAIN)
		g1:RegisterEffect(e1)
		Duel.SendtoGrave(g1,REASON_RULE)
	end
	--select option
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,94820406,12071500))
	local b2=Duel.GetFlagEffect(ep,id+1)==0
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if opt==0 then
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,94820406,12071500)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		local token=Duel.CreateToken(tp,45659520)
		Duel.SendtoGrave(token,REASON_RULE)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
