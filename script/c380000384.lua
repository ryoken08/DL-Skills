--Domination of Darkness
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
s.listed_series={0x6008,0x3008}
function s.exfilter1(c)
	return c:IsMonster() and c:IsSetCard(0x6008)
end
function s.exfilter2(c)
	return c:IsType(TYPE_FUSION) and not c:IsSetCard(0x6008)
end
function s.mdfilter(c)
	return c:IsMonster() and not (c:IsSetCard(0x6008) or c:IsSetCard(0x3008))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.exfilter1,tp,LOCATION_DECK,0,5,nil)
		and not Duel.IsExistingMatchingCard(s.mdfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.exfilter1,tp,LOCATION_EXTRA,0,5,nil)
		and not Duel.IsExistingMatchingCard(s.exfilter2,tp,LOCATION_EXTRA,0,1,nil)
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
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e:GetLabel())
end
function s.filter(c,code)
	return c.material and c:IsType(TYPE_FUSION) and c:IsSetCard(0x6008) and not c:IsCode(code)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--reveal 1 Evil HERO Fusion Monster in your Extra Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel())
	Duel.ConfirmCards(1-tp,g)
	local sg=g:GetFirst()
	--place all of the Fusion Materials specifically listed on that card from outside of your Deck to your Graveyard
	local code={table.unpack(sg.material)}
	for i=1,#code do
		if code[i]==20721928 or code[i]==58932615 or code[i]==21844576 then
			code[i]=code[i]+1
		end
		local token=Duel.CreateToken(tp,code[i])
		Duel.SendtoGrave(token,REASON_RULE)
	end
	if e:GetLabel()==0 then
		e:SetLabel(sg:GetCode())
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
