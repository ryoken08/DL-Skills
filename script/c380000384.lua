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
s.listed_names={94820406,12071500}
s.listed_series={0x8,0x6008}
function s.filter(c)
	return (c:IsMonster() and c:IsSetCard(0x6008)) or c:IsCode(94820406,12071500)
end
function s.filter2(c)
	return c:IsMonster() and not c:IsSetCard(0x8)
end
function s.exfilter(c)
	return c:IsMonster() and not c:IsSetCard(0x6008)
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
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e:GetLabel())
end
function s.filter1(c,code)
	return c.material and c:IsType(TYPE_FUSION) and c:IsSetCard(0x6008) and not c:IsCode(code)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal 1 Evil HERO Fusion Monster in your Extra Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel())
	Duel.ConfirmCards(1-tp,g)
	local sg=g:GetFirst()
	--send all Fusion Materials that are listed on it to the GY
	local code={table.unpack(sg.material)}
	for i=1,#code do
		if code[i]==20721928 or code[i]==58932615 or code[i]==21844576 then
			code[i]=code[i]+1
		end
		local token=Duel.CreateToken(tp,code[i])
		Duel.SendtoGrave(token,REASON_RULE)
	end
	e:SetLabel(0)
	e:SetLabel(sg:GetCode())
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
