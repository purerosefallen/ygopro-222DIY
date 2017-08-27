--虚太古龙·湍流神
function c10163003.initial_effect(c)
	c:SetSPSummonOnce(10163003)
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
	e2:SetCondition(c10163003.spcon)
	e2:SetOperation(c10163003.spop)
	c:RegisterEffect(e2)  
	--active
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10163003,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,10163003)
	e3:SetCost(c10163003.accost)
	e3:SetTarget(c10163003.actg)
	e3:SetOperation(c10163003.acop)
	c:RegisterEffect(e3)  
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10163003.antarget)
	c:RegisterEffect(e8)
end
function c10163003.antarget(e,c)
	return c~=e:GetHandler()
end
function c10163003.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c10163003.acfilter(c,e,tp,eg,ep,ev,re,r,rp)
    if aux.IsCodeListed(c,10160001) and c:GetType()==TYPE_SPELL and c:IsAbleToGraveAsCost() then
		   if c:CheckActivateEffect(false,true,false)~=nil then return true end
		   local te=c:GetActivateEffect()
		   local con=te:GetCondition()
		   if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		   local tg=te:GetTarget()
		   if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	end
	return false
end
function c10163003.acop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10163003.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10163003.acfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10163003.acfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c10163003.acfilter(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	else
		te=tc:GetActivateEffect()
	end
	Duel.SendtoGrave(g,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c10163003.rfilter(c,tp,ct,ec)
	return (c:IsLevelAbove(8) or c:IsAttribute(ATTRIBUTE_WATER)) and ((ct==1 and Duel.CheckReleaseGroupEx(tp,c10163003.rfilter,1,c,tp,0)) or ct==0) and c~=ec
end
function c10163003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then return Duel.CheckReleaseGroupEx(tp,c10163003.rfilter,2,c,tp,0,c)
	else return Duel.CheckReleaseGroup(tp,c10163003.rfilter2,1,c,tp,1,c)
	end
	return false
end
function c10163003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroupEx(tp,c10163003.rfilter,2,2,c,tp,0,c)
	   Duel.Release(g1,REASON_COST)
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g1=Duel.SelectReleaseGroup(tp,c10163003.rfilter,1,1,c,tp,1,c)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g2=Duel.SelectReleaseGroupEx(tp,c10163003.rfilter,1,1,g1:GetFirst(),tp,0,c)
	   g1:Merge(g2)
	   Duel.Release(g1,REASON_COST)
	end
end