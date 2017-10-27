--爱莎-星界游行
function c60150803.initial_effect(c)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9342162,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60150803)
	e2:SetCondition(c60150803.sscon)
	e2:SetTarget(c60150803.sstg)
	e2:SetOperation(c60150803.ssop)
	c:RegisterEffect(e2)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95503687,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,60150803)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c60150803.spcost)
	e1:SetTarget(c60150803.sptg)
	e1:SetOperation(c60150803.spop)
	c:RegisterEffect(e1)
end
function c60150803.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c60150803.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c60150803.filter(c)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c60150803.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c60150803.cfilter(c)
	return c:GetSequence()==0 and c:IsAbleToRemove()
end
function c60150803.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  Duel.BreakEffect()
			local c=e:GetHandler()
			local res=0
			res=Duel.TossCoin(tp,1)
			if res==0 then
				local g=Duel.GetFieldCard(tp,LOCATION_DECK,0)
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
				if g:IsType(TYPE_MONSTER) then
					e:SetLabel(0)
				end
				if g:IsType(TYPE_SPELL) then
					e:SetLabel(1)
				end
				if g:IsType(TYPE_TRAP) then
					e:SetLabel(2)
				end
			end
			if res==1 then
				local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
				if g:IsType(TYPE_MONSTER) then
					e:SetLabel(0)
				end
				if g:IsType(TYPE_SPELL) then
					e:SetLabel(1)
				end
				if g:IsType(TYPE_TRAP) then
					e:SetLabel(2)
				end
			end 
			local tc=e:GetLabel()
			local g1=Duel.GetMatchingGroup(c60150803.filter,tp,LOCATION_DECK,0,nil)
			if tc==0 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150803,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				Duel.BreakEffect()
				local sg=g1:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
			local g2=Duel.GetMatchingGroup(c60150803.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if tc==1 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150803,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				Duel.BreakEffect()
				local sg=g2:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end 
			if tc==2 then
				local g3=Duel.GetMatchingGroup(c60150803.cfilter,tp,0,LOCATION_DECK,nil)
				Duel.Remove(g3,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
function c60150803.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60150803.filter23(c,e,tp)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c60150803.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c60150803.filter23(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c60150803.filter23,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150803.filter23,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150803.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		--xyz limit
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(60150822,0))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e4:SetValue(c60150803.xyzlimit)
		e4:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
function c60150803.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER))
end