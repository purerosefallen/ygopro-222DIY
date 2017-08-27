--★武旦の魔女　Ophelia（オフェリア）
function c114000025.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000025.spcon)
	e1:SetTarget(c114000025.sptg)
	e1:SetOperation(c114000025.spop)
	c:RegisterEffect(e1)
end
--sp summon function
function c114000025.filter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) --0x224
		or c:IsSetCard(0xcabb) ) 
		and c:IsReason(REASON_DESTROY)
end
function c114000025.cfilter(c)
	return c:IsSetCard(0xcabb) 
	and c:IsAbleToRemove()
	and c:IsType(TYPE_MONSTER)
end
function c114000025.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c114000025.filter,1,nil,tp)
end
function c114000025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c114000025.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
--spsummon process
function c114000025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
	and Duel.IsExistingMatchingCard(c114000025.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) --do not sp summon if no target exist
	then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local g=Duel.SelectMatchingCard(tp,c114000025.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		 local tc=g:GetFirst()
		 local shuf=false
		 if not tc:IsLocation(LOCATION_DECK) then shuf=true end
		 Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		 if shuf then Duel.ShuffleDeck(tp) end
	end
end