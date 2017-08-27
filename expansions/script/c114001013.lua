--★黒い魔法少女 呉キリカ
function c114001013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114001013.hcon)
	c:RegisterEffect(e1)
	--special
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND) --+LOCATION_GRAVE
	e2:SetCountLimit(1,114001013)
	e2:SetCondition(c114001013.spcon)
	e2:SetCost(c114001013.spcost)
	e2:SetTarget(c114001013.sptg)
	e2:SetOperation(c114001013.spop)
	c:RegisterEffect(e2)
end
function c114001013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcabb)
end
function c114001013.hcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c114001013.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c114001013.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c114001013.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c114001013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114001013.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c114001013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c114001013.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(5)
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114001013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114001013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114001013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114001013.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,204,tp,tp,false,false,POS_FACEUP)
		--local e1=Effect.CreateEffect(e:GetHandler())
		--e1:SetDescription(aux.Stringid(114001013,0))
		--e1:SetType(EFFECT_TYPE_FIELD)
		--e1:SetRange(LOCATION_MZONE)
		--e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		--e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		--e1:SetTargetRange(0xff,0xff)
		--e1:SetValue(LOCATION_REMOVED)
		--e1:SetReset(RESET_EVENT+0x1fe0000)
		--g:GetFirst():RegisterEffect(e1)
	end
end