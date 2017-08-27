--东洋的航海家
function c2116005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c2116005.target)
	e1:SetOperation(c2116005.activate)
	c:RegisterEffect(e1)
end
function c2116005.filter1(c)
	return c:IsCode(2116000) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c2116005.filter2(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2116005.filter3(c)
	return c:IsCode(2116000) and c:IsDiscardable()
end
function c2116005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local v={
		Duel.IsExistingMatchingCard(c2116005.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c2116005.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0,
		Duel.IsExistingMatchingCard(c2116005.filter3,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	}
	if chk==0 then return v[1] or v[2] end
	local selt={tp}
	local keyt={}
	for i=1,2 do
		if v[i] then
			table.insert(selt,aux.Stringid(2116005,i-1))
			table.insert(keyt,i)
		end
	end
	local sel=keyt[Duel.SelectOption(table.unpack(selt))+1]
	c:RegisterFlagEffect(1,RESET_EVENT+0x1fe0000+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(2116005,sel-1))
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,LOCATION_GRAVE,tp,1)
	else
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
	e:SetLabel(sel)
end
function c2116005.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c2116005.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end