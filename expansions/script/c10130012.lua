--超Σ构筑 无畏级战舰
function c10130012.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c10130012.fscondition)
	e0:SetOperation(c10130012.fsoperation)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10130012.spcon)
	e2:SetOperation(c10130012.spop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)   
end
function c10130012.ffilter(c)
	return c:IsFusionSetCard(0xa336) and not c:IsType(TYPE_SYNCHRO)
end
function c10130012.fscondition(e,g,gc)
	if g==nil then return true end
	if gc then return false end
	return g:IsExists(c10130012.ffilter,2,nil)
end
function c10130012.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	Duel.SetFusionMaterial(eg:FilterSelect(tp,c10130012.ffilter,2,eg:GetCount(),nil))
end
function c10130012.spfilter1(c)
	return c:IsFusionSetCard(0xa336) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and not c:IsType(TYPE_SYNCHRO)
end
function c10130012.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local g=Duel.GetMatchingGroup(c10130012.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if g:GetCount()<2 then return false end
	return g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>=ct
end
function c10130012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local mg=Duel.GetMatchingGroup(c10130012.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g,tc=Group.CreateGroup()
	if ct>0 then
	   while ct<=0 do
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		  tc=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		  mg:RemoveCard(tc)
		  g:AddCard(tc)
	   ct=ct-1
	   end
	end
	if (g:GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(10130012,0))) or g:GetCount()<2 then
	   local g2=mg:Select(tp,1,mg:GetCount(),nil)
	   g:Merge(g2)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local nt=Duel.GetOperatedGroup():GetClassCount(Card.GetCode)
	if nt>=2 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetDescription(aux.Stringid(10130012,1))
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetCode(EFFECT_UPDATE_ATTACK)
	   e1:SetReset(RESET_EVENT+0xff0000)
	   e1:SetValue(c10130012.atkval)
	   c:RegisterEffect(e1)
	end
	if nt>=4 then
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetDescription(aux.Stringid(10130012,2))
	   e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	   e2:SetRange(LOCATION_MZONE)
	   e2:SetReset(RESET_EVENT+0xff0000)
	   e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	   e2:SetValue(aux.tgoval)
	   c:RegisterEffect(e2)
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	   e3:SetRange(LOCATION_MZONE)
	   e3:SetReset(RESET_EVENT+0xff0000)
	   e3:SetValue(c10130012.indval)
	   c:RegisterEffect(e3)
	end
	if nt>=6 then
	   local e4=Effect.CreateEffect(c)
	   e4:SetType(EFFECT_TYPE_SINGLE)
	   e4:SetDescription(aux.Stringid(10130012,3))
	   e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	   e4:SetCode(EFFECT_CANNOT_REMOVE)
	   e4:SetRange(LOCATION_MZONE)
	   e4:SetValue(1)
	   e4:SetReset(RESET_EVENT+0xff0000)
	   c:RegisterEffect(e4)
	   local e5=e4:Clone()
	   e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	   c:RegisterEffect(e5)
	   local e6=e4:Clone()
	   e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	   c:RegisterEffect(e6)
	   local e7=e4:Clone()
	   e7:SetCode(EFFECT_CANNOT_TO_DECK)
	   c:RegisterEffect(e7)
	   local e8=e4:Clone()
	   e8:SetCode(EFFECT_CANNOT_TO_HAND)
	   c:RegisterEffect(e8)  
	end
	if nt==8 then
	   local e9=Effect.CreateEffect(c)
	   e9:SetType(EFFECT_TYPE_SINGLE)
	   e9:SetCode(EFFECT_IMMUNE_EFFECT)
	   e9:SetDescription(aux.Stringid(10130012,4))
	   e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	   e9:SetValue(c10130012.efilter)
	   e9:SetRange(LOCATION_MZONE)
	   e9:SetOwnerPlayer(tp)
	   e9:SetReset(RESET_EVENT+0xff0000)
	   c:RegisterEffect(e9)
	end
end
function c10130012.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10130012.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*800
end
function c10130012.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa336)
end
function c10130012.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c10130012.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end