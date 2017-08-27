--★くるみ割りの魔女 Homulilly
function c114000918.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c114000918.hspcost)
	e1:SetTarget(c114000918.hsptg)
	e1:SetOperation(c114000918.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,114000917)
	e2:SetCondition(c114000918.descon)
	e2:SetTarget(c114000918.destg)
	e2:SetOperation(c114000918.desop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c114000918.regcon)
	e3:SetOperation(c114000918.regop)
	c:RegisterEffect(e3)
end
--special summon itself
function c114000918.rfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcabb)
end
function c114000918.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000918.rfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000918.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114000918.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000918.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--destroy
function c114000918.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re 
	and ( rc:IsSetCard(0xcabb) or rc:IsSetCard(0x223) or rc:IsSetCard(0x224)
	or rc:IsCode(36405256) or rc:IsCode(54360049) or rc:IsCode(37160778) or rc:IsCode(27491571) or rc:IsCode(80741828) or rc:IsCode(90330453) --0x223
	or rc:IsCode(32751480) or rc:IsCode(78010363) or rc:IsCode(39432962) or rc:IsCode(67511500) or rc:IsCode(62379337) or rc:IsCode(23087070) or rc:IsCode(17720747) or rc:IsCode(98358303) or rc:IsCode(91584698) ) --0x224
	and e:GetHandler():GetSummonType()~=SUMMON_TYPE_PENDULUM
end

function c114000918.desfilter(c)
	return c:IsDestructable() -- and c:IsFaceup()
end

function c114000918.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c114000918.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c114000918.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c114000918.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--remove
function c114000918.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x40)==0x40
end
function c114000918.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,114000917)
	e1:SetTarget(c114000918.thtg)
	e1:SetOperation(c114000918.thop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c114000918.filter(c,e,tp)
	return c:IsSetCard(0xcabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(7)
end
function c114000918.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114000918.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114000918.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,302,tp,tp,false,false,POS_FACEUP)
	end
end
