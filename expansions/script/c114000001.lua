--★合成魔法少女 聖カンナ
function c114000001.initial_effect(c)
	--remove & special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	---On trigger selectable
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c114000001.target)
	e1:SetOperation(c114000001.operation)
	c:RegisterEffect(e1)
	--sp summon for XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c114000001.spcon)
	e2:SetTarget(c114000001.sptg)
	e2:SetOperation(c114000001.spop)
	c:RegisterEffect(e2)
end
--filter for the field
function c114000001.filter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() 
	and c:IsSetCard(0xcabb) 
	and c:IsAbleToRemove() and lv>0 
	and Duel.IsExistingMatchingCard(c114000001.spfilter,tp,LOCATION_DECK,0,1,nil,lv+3,e,tp)
end
--filter for the deck
function c114000001.spfilter(c,lv,e,tp)
	return ( c:IsSetCard(0x223) or c:IsSetCard(0x224)
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224
	and c:GetLevel()<=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114000001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c114000001.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c114000001.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c114000001.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114000001.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or Duel.Remove(tc,0,REASON_EFFECT)==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c114000001.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel()+3,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c114000001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
end
function c114000001.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER)
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224)
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) --0x224 
	or c:IsSetCard(0xcabb) ) --and c:IsCanBeXyzMaterial(xyz)
end
function c114000001.filter3(c,e,tp)
	return ( not c:IsType(TYPE_TOKEN) )
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224)
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) --0x224 
	or c:IsSetCard(0xcabb) ) --and c:IsCanBeXyzMaterial(xyz)
	and c:IsFaceup()
end
function c114000001.spfilter2(c,e,tp)
	return c:GetRank()==4 and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c114000001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114000001.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c114000001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(c114000001.filter2,tp,LOCATION_GRAVE,0,c)
	local g2=Duel.GetMatchingGroup(c114000001.filter3,tp,LOCATION_MZONE,0,c)
	local necro_count=g1:Filter(Card.IsHasEffect,nil,EFFECT_NECRO_VALLEY)
	if necro_count:GetCount()>0 and Duel.IsChainDisablable(0) then
		Duel.NegateEffect(0) -- for necro valley
		return
	end 
	local tc=Duel.SelectMatchingCard(tp,c114000001.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=tc:GetFirst()
	if sc then
		local cg=Group.FromCards(c)
		local exmg=Group.FromCards(g1,g2)
		local xyzlay=Group.CreateGroup()
		--
		sc:SetMaterial(cg)
		if g1:GetCount()>0 then 
			--for xyz monsters
			local g1tc=g1:GetFirst()
			while g1tc do
			--get all overlay materials
				if g1tc:IsType(TYPE_XYZ) and g1tc:IsLocation(LOCATION_MZONE) and g1tc:IsFaceup() then
					xyzlay:Merge(g1tc:GetOverlayGroup())
				end
				g1tc=g1:GetNext()
			end
			--
			sc:SetMaterial(g1)
		end
		if g2:GetCount()>0 then 
			--for xyz monsters
			local g2tc=g2:GetFirst()
			while g2tc do
			--get all overlay materials
				if g2tc:IsType(TYPE_XYZ) and g2tc:IsLocation(LOCATION_MZONE) and g2tc:IsFaceup() then
					xyzlay:Merge(g2tc:GetOverlayGroup())
				end
				g2tc=g1:GetNext()
			end
			--
			sc:SetMaterial(g2)
		end
		--
		if xyzlay:GetCount()>0 then Duel.SendtoGrave(xyzlay,REASON_RULE) end
		Duel.Overlay(sc,cg)
		if g1:GetCount()>0 then Duel.Overlay(sc,g1) end
		if g2:GetCount()>0 then Duel.Overlay(sc,g2) end
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
--

--