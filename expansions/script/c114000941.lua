--★救済の魔女　Kriemhild　Gretchen
function c114000941.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	---------------------------------
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c114000941.hspcost)
	e1:SetTarget(c114000941.hsptg)
	e1:SetOperation(c114000941.hspop)
	c:RegisterEffect(e1)
	---------------------------------
	--cannot special summon
	--c:EnableReviveLimit()
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--c:RegisterEffect(e1)
	--special summon
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetRange(LOCATION_HAND)
	--e2:SetCondition(c114000941.spcon0)
	--e2:SetOperation(c114000941.spop0)
	--c:RegisterEffect(e2)	
	--remove
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP)
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCondition(c114000941.regcon)
	--e3:SetOperation(c114000941.regpop)
	--c:RegisterEffect(e3)
	--cannot activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c114000941.aclimit)
	c:RegisterEffect(e4)
end
--
--sp summon
function c114000941.rfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcabb) and c:IsLevelAbove(5)
end
function c114000941.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000941.rfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000941.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114000941.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000941.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_REMOVE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetTarget(c114000941.remtg)
			e1:SetOperation(c114000941.remop)
			e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end

--way2
function c114000941.spfilter(c)
	return c:IsSetCard(0xcabb) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(5)
end
function c114000941.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingMatchingCard(c114000941.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114000941.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114000941.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--end of way2
--remove
function c114000941.regcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re 
	and ( rc:IsSetCard(0xcabb) or rc:IsSetCard(0x223) or rc:IsSetCard(0x224)
	or rc:IsCode(36405256) or rc:IsCode(54360049) or rc:IsCode(37160778) or rc:IsCode(27491571) or rc:IsCode(80741828) or rc:IsCode(90330453) --0x223
	or rc:IsCode(32751480) or rc:IsCode(78010363) or rc:IsCode(39432962) or rc:IsCode(67511500) or rc:IsCode(62379337) or rc:IsCode(23087070) or rc:IsCode(17720747) or rc:IsCode(98358303) or rc:IsCode(91584698) ) --0x224
	and e:GetHandler():GetSummonType()~=SUMMON_TYPE_PENDULUM
end
function c114000941.regpop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c114000941.remtg)
	e1:SetOperation(c114000941.remop)
	e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c114000941.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c114000941.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function c114000941.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_REMOVED and not re:GetHandler():IsImmuneToEffect(e) 
		and not ( re:IsActiveType(TYPE_MONSTER) and ( re:GetOwner():IsSetCard(0xcabb) or re:GetOwner():IsSetCard(0x223) or re:GetOwner():IsSetCard(0x224) ) )
end