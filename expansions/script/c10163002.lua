--虚太古龙·耀星神
function c10163002.initial_effect(c)
	c:SetSPSummonOnce(10163002)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10163002.spcon)
	e2:SetOperation(c10163002.spop)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10163002,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,10163002)
	e3:SetCost(c10163002.poscost)
	e3:SetTarget(c10163002.postg)
	e3:SetOperation(c10163002.posop)
	c:RegisterEffect(e3)  
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163002.antarget)
	c:RegisterEffect(e8)
end
function c10163002.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163002.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10163002.thfilter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsLevelAbove(8)
end
function c10163002.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10163002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c10163002.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
	  Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(tp,c10163002.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	  if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,g)
	  end
	end
end
function c10163002.rfilter(c,tp,ct,ec)
	return (c:IsLevelAbove(8) or c:IsAttribute(ATTRIBUTE_LIGHT)) and ((ct==1 and Duel.CheckReleaseGroupEx(tp,c10163002.rfilter,1,c,tp,0)) or ct==0) and c~=ec
end
function c10163002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then return Duel.CheckReleaseGroupEx(tp,c10163002.rfilter,2,c,tp,0,c)
	else return Duel.CheckReleaseGroup(tp,c10163002.rfilter2,1,c,tp,1,c)
	end
	return false
end
function c10163002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroupEx(tp,c10163002.rfilter,2,2,c,tp,0,c)
	   Duel.Release(g1,REASON_COST)
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroup(tp,c10163002.rfilter,1,1,c,tp,1,c)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g2=Duel.SelectReleaseGroupEx(tp,c10163002.rfilter,1,1,g1:GetFirst(),tp,0,c)
	   g1:Merge(g2)
	   Duel.Release(g1,REASON_COST)
	end
end