--虚太古龙·龙脉神
function c10163005.initial_effect(c)
	c:SetSPSummonOnce(10163005)
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
	e2:SetCondition(c10163005.spcon)
	e2:SetOperation(c10163005.spop)
	c:RegisterEffect(e2)  
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10163005,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,10163005)
	e3:SetCost(c10163005.drcost)
	e3:SetTarget(c10163005.drtg)
	e3:SetOperation(c10163005.drop)
	c:RegisterEffect(e3)  
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163005.antarget)
	c:RegisterEffect(e8)
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163005.antarget)
	c:RegisterEffect(e8)
end
function c10163005.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163005.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163005.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10163005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10163005.desfilter0,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c10163005.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10163005.desfilter0,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,1,2,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
	   sg=Duel.GetOperatedGroup()
	   local d1=0
	   local d2=0
	   local tc=sg:GetFirst()
	   while tc do
		  if tc then
			  if tc:GetPreviousControler()==0 then d1=d1+1
			  else d2=d2+1 end
		  end
		  tc=sg:GetNext()
	   end
	   if d1>0 and Duel.SelectYesNo(0,aux.Stringid(10163005,1)) then Duel.Draw(0,d1,REASON_EFFECT) end
	   if d2>0 and Duel.SelectYesNo(1,aux.Stringid(10163005,1)) then Duel.Draw(1,d2,REASON_EFFECT) end
	end
end
function c10163005.desfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c10163005.desfilter(c,tp)
	return c10163005.desfilter0(c) and ((c:GetOwner()==tp and Duel.IsPlayerCanDraw(tp,1)) or (c:GetOwner()~=tp and Duel.IsPlayerCanDraw(1-tp,1)))
end
function c10163005.rfilter(c,tp,ct,ec)
	return (c:IsLevelAbove(8) or c:IsAttribute(ATTRIBUTE_EARTH)) and ((ct==1 and Duel.CheckReleaseGroupEx(tp,c10163005.rfilter,1,c,tp,0)) or ct==0) and c~=ec
end
function c10163005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then return Duel.CheckReleaseGroupEx(tp,c10163005.rfilter,2,c,tp,0,c)
	else return Duel.CheckReleaseGroup(tp,c10163005.rfilter2,1,c,tp,1,c)
	end
	return false
end
function c10163005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroupEx(tp,c10163005.rfilter,2,2,c,tp,0,c)
	   Duel.Release(g1,REASON_COST)
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroup(tp,c10163005.rfilter,1,1,c,tp,1,c)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g2=Duel.SelectReleaseGroupEx(tp,c10163005.rfilter,1,1,g1:GetFirst(),tp,0,c)
	   g1:Merge(g2)
	   Duel.Release(g1,REASON_COST)
	end
end