--Darkest　先祖
function c22230161.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FLIP),2)
	c:EnableReviveLimit()
	--Change position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22230161,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c22230161.condition)
	e3:SetTarget(c22230161.target)
	e3:SetOperation(c22230161.operation)
	c:RegisterEffect(e3)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22230161,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c22230161.discost)
	e3:SetCondition(c22230161.discon)
	e3:SetTarget(c22230161.distg)
	e3:SetOperation(c22230161.disop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c22230161.spr)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22230161,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c22230161.spcon)
	e5:SetTarget(c22230161.sptg)
	e5:SetOperation(c22230161.spop)
	c:RegisterEffect(e5)
end
c22230161.named_with_Darkest_D=1
function c22230161.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230161.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return np~=pp
end
function c22230161.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22230161.cfilter,1,nil)
end
function c22230161.tgfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22230161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c22230161.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,0,1,0,0)
end
function c22230161.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c22230161.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c22230161.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp
end
function c22230161.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFacedown,nil)
	if chk==0 then return g:GetCount()>0 end
	local cc=g:Select(tp,1,1,nil)
	Duel.ChangePosition(cc,POS_FACEUP_DEFENSE)
end
function c22230161.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c22230161.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c22230161.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(r,0x41)~=0x41 or not c:IsPreviousLocation(LOCATION_ONFIELD) then return end
	if c:IsSummonType(SUMMON_TYPE_LINK) then
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			c:RegisterFlagEffect(22230161,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,0,2)
		else
			c:RegisterFlagEffect(22230161,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,0,1)
		end
	end
end
function c22230161.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(22230161)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22230161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22230161.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end